# standupmail-cli

Command line interface for StandupMail to post progress updates and request digests.

## Setup

1. Install gem:
`$ gem install standupmail-cli`
2. Authorize:
`$ sm authorize`

Open https://www.standupmail.com in your web browser and log in to your account.
If you don't have an account yet, please sign up first.
Then, go to your account settings to find your access id and generate your token.

Authorization is only required once.

## Features

Standupmail-cli brings the following features to your command line interface:

1. [List my teams](#list-my-teams)
2. [Send progress update to team](#send-progress-update-to-team)
2. [Show team digest](#show-team-digest)

### List my teams

#### Usage:

`$ sm teams`

Gives you a numbered list of your teams.

#### Example:

```
$ sm teams
[0] Management
[1] Backend Devs
[2] UI Team
```

### Send progress update to team

#### Usage:

```
$ sm [-t=<teamid>] [-d | -n | -b] (<message>)
```

Sends a progress update to the selected team.

#### Options:

```
-t            Team-ID to send message to [default: 0]
-d            DONE message
-n            NEXT message
-b            BLOCK message
```


#### Example:

```
$ sm -t 2 -d "Wrote chapter in my book"
Well done!
```

### Show team digest

#### Usage:

```
$ sm digest (<date>) -t <team number>
```

Show team digest for given date and team.

#### Example:

```
$ sm digest 18-02-2016 -t 2
--------------------------
Digest for Thu 18 Feb 2016
--------------------------

Ben:
   ✓  Signed up for StandupMail
   →  Will use StandupMail tomorrow
   ⨉  No more brew

Bart:
   ✓  Released standupmail-cli 0.1.0
   →  Fix bugs like a pro
```

## Contributing
1. Fork it ( https://github.com/Wootech/standupmail-cli/fork )
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Commit your changes ( `git commit -am 'Add some feature'` )
4. Push to the branch ( `git push origin my-new-feature` )
5. Create new Pull Request
