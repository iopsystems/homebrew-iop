# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.81",
    revision: "11ba06fcb0559a5842d91b5e0ec796525ce667ee"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.81"
    sha256 cellar: :any,                 arm64_ventura: "56b00b4cf901fd7b2db0f3d8bb23a45594a4bbcb65c3792afee0b750005f166c"
    sha256 cellar: :any,                 ventura:       "7d02053e285cd4f18bd5da66e9ea50c5d95abf7bf47724989fea1b49cc45c91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a7f715b0caa4231fbbd8333e8e98ae0e9766e5c1b18ca9cb7ecf91ff247881"
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
