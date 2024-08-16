# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitHubGitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v0.0.98",
    revision: "5f1ec974506c757a87c4654046790749342628de"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.96"
    sha256 cellar: :any,                 arm64_ventura: "7a54d0777ee664482fdc679711e5935a06785d161b09d340421b75e7ffe159b3"
    sha256 cellar: :any,                 ventura:       "78c7a82fddf05f57dd9c4f0d642c9f1c01332db1b0b73ad1ceaea41bad795bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786ecfbec39494cf4944aedcc84d1aa9e5d92681cc042b4db1a7909aaba1dabb"
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
