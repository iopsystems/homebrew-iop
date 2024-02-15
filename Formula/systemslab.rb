# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.69",
    revision: "76ce91b8ad62775b4a0af5c8ee89bc69fba1d385"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.68"
    sha256 cellar: :any,                 arm64_ventura: "af3a7c4b996fa0ee24003b5133a6bc39af052556c7b52102718e48edea1e92d8"
    sha256 cellar: :any,                 ventura:       "1a0dc7d7493232c6d4f653a0913bb1a3203851c77630b8da4987e91a44cf7c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd711025886a5673342e0a90baf75fe839a14007cc5bffa6f8a2a4aa41b478c"
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
