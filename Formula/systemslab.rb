# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.79",
    revision: "28252e39c45d824bd5bc3ea2817324afc9fc2b96"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.78"
    sha256 cellar: :any,                 arm64_ventura: "3505ad5bf48d8b9b4f68bceb4f7f6dc84a28f48285d711debfe5036561f9a7b4"
    sha256 cellar: :any,                 ventura:       "e556df751f81cced8ab09397b9625bdff13fcffea56fc1c758e936f88b5155fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b23b6ce5a4eff6fc4323741b53c7b8aebc70dc984956816456ece1f6ad7d41b"
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
