# Jenkins to GitHub uploader

This is a small ruby web app which uploads build artifcats from [Jenkins](http://jenkins-ci.org) to [GitHub](https://github.com). It is intended to run on [Heroku](http://heroku.com).

## Usage

### Requirements

- Ruby >= 1.9.2
- [Bundler](http://gembundler.com)
- [Heroku Toolbelt](https://toolbelt.heroku.com)

### Installation

Clone this repository and `cd` into your local copy. For local development install the ruby gems:

    bundle install --path vendor

Create the heroku app and push to it:

    heroku create
    heroku push heroku master

Make sure to remember the heroku app url (something like *http://some-name-some-number.herokuapp.com*).

Check if your app is runnung with `heroku ps` and then set the configuration options with `heroku config:add OPTION=value`. These options have to be set:

    JENKINS_USER=your_jenkins_user                          [optional]
    JENKINS_PW=your_jenkins_password                        [optional]
    UPLOAD_FILE_NAMES=relative_path_to_your_build_artifact  (inside your Jenkisn workspace)
    GITHUB_AUTH_USER=github_user_to_authenticate
    GITHUB_PW=github_password
    GITHUB_USER=the_user_the_repo_belongs_to                (can also be an organization)
    GITHUB_REPO=the_repo_name

### Jenkins setup

Install the [Notification Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Notification+Plugin) and add a notification to your job configuration. Choose the *http*-protocol and enter your *[heroku app url]/upload/* into the URL-field. 

## Development

You can locally test this app with the [foreman](http://github.com/ddollar/foreman) tool and your configuration settings in an `.env`-file:

    JENKINS_USER=jenkins_user > .env
    ...
    foreman start

To test requests to this app I recommend [HTTP Client](http://ditchnet.org/httpclient/).