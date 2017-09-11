defmodule Rumbl.VideoController do
    use Rumbl.Web, :controller

    alias Rumbl.Video

    def action(conn, _) do
        apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
    end

    def index(conn, _params, user) do
        videos = Repo.all(user_videos(user))
        render(conn, "index.html", videos: videos)
    end

    def new(conn, _params, user) do
        IO.inspect(:inspecting)
        IO.inspect(user |> build_assoc(:videos))
        changeset = user
                    |> build_assoc(:videos)
                    |> Video.changeset()

        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"video" => video_params}, user) do
        changeset =
            user
            |> build_assoc(:videos)
            |> Video.changeset(video_params)

        case Repo.insert(changeset) do
            {:ok, _videos} ->
                conn
                |> put_flash(:info, "Video created successfully.")
                |> redirect(to: video_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

    def show(conn, %{"id" => id}, user) do
        videos = Repo.get!(user_videos(user), id)
        render(conn, "show.html", videos: videos)
    end

    def edit(conn, %{"id" => id}, user) do
        videos = Repo.get!(user_videos(user), id)
        changeset = Video.changeset(videos)
        render(conn, "edit.html", videos: videos, changeset: changeset)
    end

    def update(conn, %{"id" => id, "video" => videos_params}, user) do
        videos = Repo.get!(user_videos(user), id)
        changeset = Video.changeset(videos, videos_params)

        case Repo.update(changeset) do
            {:ok, videos} ->
                conn
                |> put_flash(:info, "Video updated successfully.")
                |> redirect(to: video_path(conn, :show, videos))
            {:error, changeset} ->
                render(conn, "edit.html", videos: videos, changeset: changeset)
        end
    end

    def delete(conn, %{"id" => id}, user) do
        videos = Repo.get!(user_videos(user), id)

        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(videos)

        conn
        |> put_flash(:info, "Video deleted successfully.")
        |> redirect(to: video_path(conn, :index))
    end

    defp user_videos(user) do
        assoc(user, :videos)
    end

    alias Rumbl.Category

    plug :load_categories when action in [:new, :create, :edit, :update]

    defp load_categories(conn, _) do
      query =
        Category
        |> Category.alphabetical
        |> Category.names_and_ids
      categories = Repo.all query
      assign(conn, :categories, categories)
    end
end
