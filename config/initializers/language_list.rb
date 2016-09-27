module LanguageList
  POPULAR_LANGUAGES_ISO_639_3 = ['asm', 'ben', 'bhb', 'brx', 'doi', 'eng', 'gon', 'guj', 'hin',
    'hoc', 'kan', 'kas', 'khn', 'kha', 'kok', 'kru', 'mai', 'mal', 'mar', 'mni',
    'unr', 'nep', 'ori', 'pan', 'sat', 'snd', 'tam', 'tel', 'tcy', 'urd'].freeze

  POPULAR_LANGUAGES = LanguageList::ALL_LANGUAGES.select { |lang| lang.iso_639_3.in?(POPULAR_LANGUAGES_ISO_639_3) }
end
