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
    tag:      "v0.0.111",
    revision: "9b6628c23831c786eb686c781268ce908d38854f"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2419e1ad9fd7cf2245a160c2d4fdbe59ff2538e5cbb44f9a8dc6e8ab7c50a9ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7be14c5f42f15c8a25196229bb2630b37398e002f752651ba11384a61c9dd31b"
    sha256 cellar: :any_skip_relocation, ventura:       "054d14237bff3a4d8043b1a37face275a3985d906c49c478ec0fa455c288551c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61970ecdbae3d23d948ee15edf8d4a59e9e52bdd7d7fd132468e0f8bd7ad380"
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
