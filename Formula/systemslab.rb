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
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.98"
    sha256 cellar: :any,                 arm64_ventura: "1d92986d725b4d2cd1652ea146c5486d008aa9166e87807368a9530ec1aa67b3"
    sha256 cellar: :any,                 ventura:       "c21f046bba25b11040fb990323b361b49b9be7234afc5efb87540038aff66bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d83a8a2c650d73af5917303cd05d14f05f6a2594782fd3be4973d0d6285dcc9"
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
