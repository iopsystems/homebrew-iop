# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.71",
    revision: "f32ff448435919b2f1c282b7d356a0477d5bb42c"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.70"
    sha256 cellar: :any,                 arm64_ventura: "74774a76a99a49363eb62ab3c765811f1082eb5c616592a048992e1961004646"
    sha256 cellar: :any,                 ventura:       "36aa46d6bca8a3fc0a2ff98f2b2342da039725f2c8ecf63fcea7c1d6fd9a0919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b1c3c5f8c8ffcf3654e7a7caad1121008b3d47a7a0778a59ad4ac9377e9d7b"
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
