Url.find_or_create_by(short_url: 'asd', original_url: 'https://github.com')
Url.find_or_create_by(short_url: 'ASD', original_url: 'https://stackoverflow.com')
Url.find_or_create_by(short_url: '123sd', original_url: 'http://foo.com')
Url.find_or_create_by(short_url: '123AD', original_url: 'http://foo2.com')
Url.find_or_create_by(short_url: '1c3', original_url: 'https://www.fullstacklabs.co/')
Url.find_or_create_by(short_url: '123dA', original_url: 'https://www.linkedin.com/')
Url.find_or_create_by(short_url: '1s2s3', original_url: 'https://twitter.com/home')
Url.find_or_create_by(short_url: '1ff23', original_url: 'https://bar.com/home')
Url.find_or_create_by(short_url: 123, original_url: 'http://google.com')
Url.find_or_create_by(short_url: 456, original_url: 'http://facebook.com')
Url.find_or_create_by(short_url: 789, original_url: 'http://yahoo.com')