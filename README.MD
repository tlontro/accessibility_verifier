Accessibility verifier
===
---
#### 1. Environment Setup
ruby version:
  ```
  ruby 2.7.2p137
  ```
chromedriver version:
  ```
  chromedriver 96.0.4664.45
  ```

chrome version:
  ```
  chrome 96.0.4664.110
  ```
installing bundler gem to be able to use it for next gems:
  ```
  > gem install bundler
  ```
installing gems:
  ```
  > bundle
  ```
---
#### 2. Account Setup
create a json file at `spec/resources/files/setup.json`
```json
{
  "email": "<your gmail email address>",
  "password": "<your gmail password>"
}
```

---
#### 3. Test execution
`headless` (default)
  ```
  > bundle exec rspec spec
  ```
`non headless`
**debug** - true for browser view
  ```
  > debug=true bundle exec rspec spec
  ```
---
#### 4. Adding pages
