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
    tag:      "v133.0.0",
    revision: "4fe676b7f76c389e8414ea74a4b1c8c0278b859e"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-133.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "f09434f39815e1b675f891ad11a88987bdac473a3bf997307e6047e25a3bda12"
    sha256 cellar: :any,                 arm64_sonoma:  "59ccd55c27450f535342dabbb2df1780770bab1676c74d294bdf388c9abbd063"
    sha256 cellar: :any,                 arm64_ventura: "22d1e7bbb5fab57446f199a7e47ece8d093ac76fe79ecddeb2277349b9b13b65"
    sha256 cellar: :any,                 ventura:       "88e94246ace727186406c83cf807811cf0df589cc08f5140adcf280af286ee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d9e6537e1a25b58fd9945e63ff0eebac114012104c69f072865838c833f970"
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
