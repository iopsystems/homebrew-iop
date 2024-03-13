# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.75",
    revision: "dec3d40491b77de1297305581bc19b49c967b55c"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.75"
    sha256 cellar: :any,                 arm64_ventura: "49818b0c2dbc0214ad5c79710efa18acbb4cb5f6d2b5038e61c4b3d2a35623cd"
    sha256 cellar: :any,                 ventura:       "14d8015697a3cfb83c67488db44435f60b544f778f5b6f693c31a875a7890781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b392e5f868ba6eab95f8cea8b43b2598481b6215d573c885f92e61270484be8c"
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
