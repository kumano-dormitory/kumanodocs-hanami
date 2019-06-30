# Kumanodocs-Hanami
Document System for the Meetings in Kumano-Dormitory
built with [hanami](https://github.com/hanami/hanami)

## Setup

Before setup, install Docker, add user to Docker group.

```shell-session
$ ./config/database_up.sh
$ bundle install --path vendor/bin
$ bundle exec hanami db prepare
$ bundle exec hanami server
$ bundle exec rake seed
```

And then, open [http://localhost:2300](http://localhost:2300).

## Application
**web:**
- Main web page for general users.
- Users are able to view articles, post new articles, and edit the articles.
- Users are able to search articles and download PDF.

**admin:**
- Admin web page for admin users.
- Admin users are able to create new meeting and edit all meetings.
- Admin users are able to view all articles, create new articles, edit all articles, and change status of articles (order, printed?, checked?, etc...).
- Admin users are able to change order of articles and then download PDF.

**api:**
- API for smartphone application.
- API returns json data of meetings, articles, comments, etc...
- API generates JWT for accessing API.

## Model
### Article
| attribute | type | |
| ----- | ----- | -----|
| id | Primary key | |
| title | String | |
| body | String | |
| number | Integer | |
| format | Integer | 0:text, 1:markdown |
| checked | Boolean | |
| printed | Boolean | |
| author_id | Foreign key | on delete cascade |
| meeting_id | Foreign key | on delete cascade |

### Meeting
| attribute | type |  |
| ----- | ----- | ---- |
| id | Primary key |  |
| date | Date |  |
| deadline | DateTime |  |
| type | Integer | 0:default(BlockMeeting), 1: GeneralMeeting |

### Author
| attribute | type |
| ----- | ----- |
| id | Primary key |
| name | String |
| crypt_password | String |
| lock_key | String |

### Category
| attribute | type | |
| ----- | ----- | ----- |
| id | Primary key | |
| name | String | |
| require_content | Boolean | true: requires VoteContent, false: not requires |

### ArticleCategory
| attribute | type | |
| ----- | ----- | ----- |
| id | Primary key | |
| extra_content | String | for VoteContent |
| article_id | Foreign key | on delete cascade |
| category_id | Foreign key | on delete cascade |

### Comment
| attribute | type | |
| ----- | ----- | ----- |
| id | Primary key | |
| body | String | |
| crypt_password | String | |
| article_id | Foreign key | on delete cascade |
| block_id | Foreign key | on delete cascade |

### Block
| attribute | type |
| ----- | ----- |
| id | Primary key |
| name | String |

### Table
| attribute | type | |
| ----- | ----- | ----- |
| id | Primary key | |
| caption | String | |
| csv | String | |
| article_id | Foreign key | on delete cascade |

### VoteResult
| attribute | type | |
| ----- | ----- | ----- |
| id | Primary key | |
| agree | Integer | |
| disagree | Integer | |
| onhold | Integer | |
| crypt_password | String | |
| article_id | Foreign key | on delete cascade |
| block_id | Foreign key | on delete cascade |

### Message
| attribute | type | |
| ----- | ----- | ----- |
| id | Primary key | |
| body | String | |
| send_by_article_author | Boolean | |
| comment_id | Foreign key | on delete cascade |
| author_id | Foreign key | on delete cascade |

### ArticleReference
| attribute | type | |
| ---- | ---- | ---- |
| article_old_id | Primary & Foreign key | on delete cascade |
| article_new_id | Primary & Foreign key | on delete cascade |
| same | Boolean | |

## Lint

Rubocop is ready to use!

```shell-session
$ bundle exec rubocop
```

## Test

Test is written in RSpec. To run test:

```shell-session
$ HANAMI_ENV=test bundle exec hanami db prepare
$ bundle exec rake test
```
