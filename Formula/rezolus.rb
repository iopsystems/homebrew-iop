# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "7655d85cfafe3e8622cea6c5d37d2b59c444ecbcba84f227218dfa3052371870"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.19.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28b5900a27fde3342f22e68ce8e3f03500faaa464e5be2fd9e394b379506119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "996186e86fbfe8f5f35b9c9fed1137412b5f17163693875aec019c71b5320f27"
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
