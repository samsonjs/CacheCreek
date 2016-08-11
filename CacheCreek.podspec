Pod::Spec.new do |s|
  s.name = 'CacheCreek'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'An LRU cache that can hold anything, including native Swift types.'
  s.homepage = 'https://github.com/samsonjs/CacheCreek'
  s.authors = { 'Christopher Luu' => 'nuudles@gmail.com', 'Sami Samhuri' => 'sami@samhuri.net' }
  s.source = { :git => 'https://github.com/samsonjs/CacheCreek.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
