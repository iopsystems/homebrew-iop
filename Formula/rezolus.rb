# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.17.0.tar.gz"
  sha256 "d2964e02282873d6f00ef4e5a0924324105e3056cdaeb58bccd5d7380c1ddb80"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.16.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e4a1e5c360b9274e32b7b35238d7200fcfc048cc1e5951b11d8ab3af4bca2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f95f54dcfb927e65c9477ced7e606fef396d90b0db24b0f901807592e76203"
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
