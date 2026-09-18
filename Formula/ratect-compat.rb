class RatectCompat < Formula
  desc "A strict, flag-for-flag and field-for-field drop-in replacement for the (now-unmaintained) batect binary"
  homepage "https://github.com/or1can/ratect"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.30.0/ratect-compat-aarch64-apple-darwin.tar.xz"
      sha256 "6e10369039e9c2d0034f1f304613c9e0de75bd30f28929842615a82ee02da9ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.30.0/ratect-compat-x86_64-apple-darwin.tar.xz"
      sha256 "539f3a519268fd7106af581cfff62cfe6ead1dab894e1b2140b23f9b76c21986"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.30.0/ratect-compat-aarch64-unknown-linux-musl.tar.xz"
      sha256 "72db5b95e70b45ea7b7c46c9826c571e128247fc53f96e227d7101898d881cbc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.30.0/ratect-compat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1506e81f5952c686e7d0d7dae4e317c0e86c17a8c95323fea5bf6c2cf57c87ac"
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
      bin.install "ratect-compat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ratect-compat"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ratect-compat"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ratect-compat"
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
