# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.68",
    revision: "c0b7fda5e800044e67fe0336d9d99c7777cda5a4"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.67"
    sha256 cellar: :any,                 arm64_ventura: "7ad429ce4de41d7e761682cfa9fd4b95ab35da18cb76d89f6d8babf566c13cb1"
    sha256 cellar: :any,                 ventura:       "09d3a9f1f2bc78b5955ba96b16d890cb2dc6e0c44d420e8eb38659564851fe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569f6fe432d0731c6aac87f6134057dea2f5e1dfb1b08755cb0a3b800789a7ca"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "bzip2"
  depends_on "openssl"
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
