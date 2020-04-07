from instapy import InstaPy
import os

// Instapy Documentation: https://github.com/timgrossmann/InstaPy/blob/master/DOCUMENTATION.md

session = InstaPy(username=os.environ.get('USER'), password=os.environ.get('PASS'))
session.login()

//Set quota limits to keep Instagram from banning you because it thinks you're a bot

session.set_quota_supervisor(enabled=True, sleep_after=["likes", "comments_d", "follows", "unfollows", "server_calls_h"], sleepyhead=True, stochastic_flow=True, notify_me=False,
peak_likes_hourly=51, peak_likes_daily=385, peak_comments_hourly=12, peak_comments_daily=82, peak_follows_hourly=18, peak_follows_daily=411, peak_unfollows_hourly=35,
peak_unfollows_daily=402, peak_server_calls_hourly=None, peak_server_calls_daily=4200)

// Like the images matching either of these tags and not some others
session.like_by_tags(["novels", "books", "authors", "writers" "reading"], amount=5)
session.set_dont_like(["mein kampf", "nsfw"])

// Auto-follow half of the time
session.set_do_follow(True, percentage=50)

// Auto-Commenting - Disabled by default
session.set_do_comment(False, percentage=50)
session.set_comments(["Nice!", "Sweet!", "Beautiful :heart_eyes:"])

session.end()
