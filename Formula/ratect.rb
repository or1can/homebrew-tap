class Ratect < Formula
  desc "The forward-looking Ratect CLI, free to diverge from Batect's interface"
  homepage "https://github.com/or1can/ratect"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.8.0/ratect-aarch64-apple-darwin.tar.xz"
      sha256 "840665010667b8200f24a6a2981f2bbc578f09af40230d63dde9f28bed6cf592"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.8.0/ratect-x86_64-apple-darwin.tar.xz"
      sha256 "46f945b9c010fe065f4b2403a383b018c94abd0a7a4b556797576505cf69335b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.8.0/ratect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1e3cd6f88e54829a22b0b0169d4b96d598d0c2f12d0e0eb7f9e21ffdda8b01ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.8.0/ratect-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dbbf14560709fc9bd179599c537932e2c72a7bf53c7b44a1b56ed0896dc42660"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ratect"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ratect"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ratect"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ratect"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
