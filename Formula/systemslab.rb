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
    tag:      "v126.0.0",
    revision: "977132232276620695dcd8c2f97b3f5bf89e94b2"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-125.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ffacb9b705481ba141a6b6eb64ba390f7b48524a2ce66b7b1d72da4d512299"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edea8f9452180f34cf70c68094fc537292a4b7e57e3b18588b58d7537a06510c"
    sha256 cellar: :any_skip_relocation, ventura:       "b3c20d6cefa14c12281f3a86ecebcb58ced686ec3ca5df570dceb3e70d13bc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5712238df41499d233ad866ff300568be0d31fa64516199cc73e0c0b235977"
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
