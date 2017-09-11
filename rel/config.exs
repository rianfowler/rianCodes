use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :riancodes,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"?1t1Y_o^CI@YZG_ah>_,<68e;6d}.cq8,BR2`d!a6EjnC70;*uV!6%<6JaQX`,!k"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"f1R<yt`CnsSSm4*S0K6.<W0OcbpHC9hp$bCxQoOP=es/(M=kqPP5K:x~HRr8qc^6"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :riancodes do
  set version: "0.1.0"
  set applications: [:info_sys, :rumbl]
end

release :info_sys do
  set version: current_version(:info_sys)
end

release :rumbl do
  set version: current_version(:rumbl)
end

