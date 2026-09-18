class Ratect < Formula
  desc "The forward-looking Ratect CLI, free to diverge from Batect's interface"
  homepage "https://github.com/or1can/ratect"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.9.0/ratect-aarch64-apple-darwin.tar.xz"
      sha256 "2882c54a52cd6ab0c95e63347946c294678ffd31cf1ad54dd06068ff48ed3842"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.9.0/ratect-x86_64-apple-darwin.tar.xz"
      sha256 "afbf327d4f3a653b156e5a4560bc3d1f24d6bb2be34e2b427131d6572f0d97c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.9.0/ratect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cafc60daebd212b432f6ede3af1b36ce2d195f73931c1e119b065206c56a319a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.9.0/ratect-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2e6e9e87bcc72e2006fc8d90cfbe14814898c307bf3c24e418c9d1597266bce2"
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
