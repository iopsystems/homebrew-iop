# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v129.0.0",
    revision: "be6d63d14e531ffea46a0acac3b8a19a3b16b9ae"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-129.0.0"
    sha256 cellar: :any,                 arm64_sonoma:  "e63e5cfa86e788e05ca0fb932b11f98fc054a9e304e6a43d9ffa97dcd0918d69"
    sha256 cellar: :any,                 arm64_ventura: "f67167fae388dee81ae352fc923eddf765a32579f7d1c3d9d0e1f8b98fab0bf4"
    sha256 cellar: :any,                 ventura:       "b49bb161325e03e95e35a97566394eee29680e994aab5c923405ab82505e41e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e6506f7035bf66db46609d41cc296ad4d8933702999a4614f8cdad9a7a139c"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "bzip2"
  depends_on "openssl@3"
  depends_on "xz"

  def install
    system "cargo", "install",
      "--bin", "systemslab",
      "--path", "crates/cli",
      "--profile", "prod",
      "--locked",
      "--root", prefix

    system prefix/"bin"/"systemslab", "completions", "bash", "-o", "systemslab"
    system prefix/"bin"/"systemslab", "completions", "fish", "-o", "systemslab.fish"
    system prefix/"bin"/"systemslab", "completions", "zsh", "-o", "_systemslab"

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
    bash_completion.install "systemslab"
    fish_completion.install "systemslab.fish"
    zsh_completion.install "_systemslab"
  end

  test do
    content = <<-EOM
      local systemslab = import "systemslab.libsonnet";

      {
        name: 'test experiment',
        jobs: {
          test_job: {
            steps: [
              systemslab.bash('true')
            ]
          }
        }
      }
    EOM

    File.write("test.jsonnet", content)

    system "#{bin}/systemslab", "evaluate", "test.jsonnet"
  end
end
