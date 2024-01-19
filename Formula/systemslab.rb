# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.62",
    revision: "8c21e78c2ed0aeda461acbdcefa8074b5a598f70"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.62"
    sha256 cellar: :any,                 arm64_ventura: "6e47d2503e595de57ebf47e807e29781ac3e386fff20563fd64428faf8758067"
    sha256 cellar: :any,                 ventura:       "9e7d35dd47d19309a31a6eb30ca71638dc54e7e523f0a5cf9a406ef069079ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a1c668cc6a02e1701551c6c30305a914474f0b1ae130b48ff59d2f0a5779965"
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
