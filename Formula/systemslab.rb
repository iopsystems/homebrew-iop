# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v0.0.109",
    revision: "eb70a8cd6bc7c9428a773238e060fd9cead27792"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a75bc59835a177f672b31876ecbb6fccecfe72caee5e5eec95e4b412000484"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f318573769a9d556468f27be6321494a44012a236ff84ec87999f2c0bcaa64f7"
    sha256 cellar: :any_skip_relocation, ventura:       "91cff96428f980c38e5d846c27ab8428354e228e75d0214b5417871345f55f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb566a54b19b889295a7a250aafa4b4eb9ed61b7d7886387bb4f8614e0e9350b"
  end

  depends_on "go" => :build
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

    system prefix/"bin"/"systemslab", "completions", "bash", "-o", "systemslab"
    system prefix/"bin"/"systemslab", "completions", "fish", "-o", "systemslab.fish"
    system prefix/"bin"/"systemslab", "completions", "zsh", "-o", "_systemslab"

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
    bash_completion.install "systemslab"
    fish_completion.install "systemslab.fish"
    zsh_completion.install "_systemslab"
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
