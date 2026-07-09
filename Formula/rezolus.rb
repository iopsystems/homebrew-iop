# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "46abfbe61e4426528a40b1d71eb1730f900504407eb08aada3dda2991573c4cc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.16.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a64986261b4f0049c1a11187212aa09f3385adf4eb74230940e873d8979ace7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f70e2649f95a285a0b60ddcf261cf811edd4d0b51190c153b8e05a1ad376392"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = formula_opt_bin("llvm")/"clang"
    ENV["CXX"] = formula_opt_bin("llvm")/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
