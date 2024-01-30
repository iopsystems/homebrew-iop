# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.65",
    revision: "b6c2a6f659942b27ae8e4849e93b74def3e6b083"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.64"
    sha256 cellar: :any,                 arm64_ventura: "31a09ea0922d8a68592e7d7f85c68e343199f9cf7aa442ee2b7aeae03e6cc567"
    sha256 cellar: :any,                 ventura:       "df34bb6f8667b8b9dea427da257530340a5a1b9f232a8ebeadffc57d08702143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742bb7383387e4200b29b2422f65bff358221fe589ee10e318d2e929ba7ef928"
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
