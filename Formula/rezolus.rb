# Brew formula for the SystemsLab CLI.

class Rezolus < Formula
  desc      "High-resolution, low-overhead systems telemetry via eBPF. Package contains metrics agent, multiple OTel or Parquet recorders, and an HTTP dashboard viewer."
  homepage  "https://rezolus.com"
  url       "https://github.com/iopsystems/rezolus.git",
    tag:      "v5.1.0",
    revision: "946dbc675733bfd15050ca2d7dfa443033cbe912"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build
  depends_on "protobuf" => :build


  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
