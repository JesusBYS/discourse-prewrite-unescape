# name: discourse-prewrite-unescape
# about: Replaces \u003e with > in post raw before saving
# version: 1.0
# authors: You
# url: https://github.com/<YOU>/discourse-prewrite-unescape

after_initialize do
  module ::PrewriteUnescape
    def self.fix(raw)
      return raw if raw.blank?
      raw.gsub(/\\\\u003e|\\u003e/, ">")
    end
  end

  module ::PrewriteUnescapePostCreator
    def initialize(user, opts)
      if opts.is_a?(Hash) && opts[:raw].present?
        opts = opts.dup
        opts[:raw] = ::PrewriteUnescape.fix(opts[:raw])
      end
      super(user, opts)
    end
  end

  module ::PrewriteUnescapePostRevisor
    def revise!(editor, fields, opts = {})
      if fields.is_a?(Hash) && fields[:raw].present?
        fields = fields.dup
        fields[:raw] = ::PrewriteUnescape.fix(fields[:raw])
      end
      super(editor, fields, opts)
    end
  end

  ::PostCreator.prepend(::PrewriteUnescapePostCreator)
  ::PostRevisor.prepend(::PrewriteUnescapePostRevisor)
end
