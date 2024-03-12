# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.74",
    revision: "482959bb49067eec2866f99629a07517459743af"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.73"
    sha256 cellar: :any,                 arm64_ventura: "a97e91217d9bb34897f5ab918c34cee99a4538e8073540e4d2faa266d069a715"
    sha256 cellar: :any,                 ventura:       "dde7ce3662312a408f4bd5a2268fb34664480b6c7d544c61ebe8da861e37d066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56280c2900a61eb7a36d9ebb1224b2987f7effe68a490ed09e53d115661589d0"
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
