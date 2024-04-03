# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.80",
    revision: "75410c437948b8c5463c7a4c75bc3511d3d79467"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.80"
    sha256 cellar: :any,                 arm64_ventura: "f9027fce610c8fbd946e8cbba61ddc37e7b44c55d57fd034da8b8de920a0191c"
    sha256 cellar: :any,                 ventura:       "9713cd80a55afcd20dd9be20203a07a3ad0420313577a67ab187b5424dfaef61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca0628028e0e814997d954d7f7a3dfd9322ccb2ae605d246c7ae90c802abc5a"
  end

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

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
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
