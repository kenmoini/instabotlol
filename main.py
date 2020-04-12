import os
import sys
from http.server import HTTPServer, CGIHTTPRequestHandler
import threading
from instapy import InstaPy

## Start a simple HTTP Server

def start_server(path, port=8000):
    '''Start a simple webserver serving path on port'''
    os.chdir(path)
    httpd = HTTPServer(('', port), CGIHTTPRequestHandler)
    httpd.serve_forever()

# Start the server in a new thread
port = 8000
daemon = threading.Thread(name='daemon_server', target=start_server, args=('./healthz/', port))
daemon.setDaemon(True) # Set as a daemon so it will be killed once the main thread is dead.
daemon.start()

## Instapy Documentation: https://github.com/timgrossmann/InstaPy/blob/master/DOCUMENTATION.md

session = InstaPy(username=os.environ.get('USER'), password=os.environ.get('PASS'), headless_browser=True)
session.login()

session.set_simulation(enabled=False)

## Set quota limits to keep Instagram from banning you because it thinks you're a bot

session.set_quota_supervisor(enabled=True, sleep_after=["likes", "comments_d", "follows", "unfollows", "server_calls_h"], sleepyhead=True, stochastic_flow=True, notify_me=False,
peak_likes_hourly=51, peak_likes_daily=385, peak_comments_hourly=12, peak_comments_daily=82, peak_follows_hourly=18, peak_follows_daily=411, peak_unfollows_hourly=35,
peak_unfollows_daily=402, peak_server_calls_hourly=None, peak_server_calls_daily=4200)

## Like the images matching either of these tags and not some others
session.like_by_tags(["novels", "books", "authors", "writers", "reading", "WriterCommunity", "WritingTips", "WritingPrompts"], amount=8)
session.set_dont_like(["mein kampf", "nsfw"])

## Auto-follow half of the time
session.set_do_follow(enabled=True, percentage=10, times=1)

## Auto-Commenting - Disabled by default
session.set_do_comment(enabled=True, percentage=100)
session.set_comments(["Nice!", "Sweet!", "I really like this", "Great Content!", "Awesome!", "Interesting!", "We just released a new book, The Stray, care to take a look?", "We're a new indie publisher, check us out!", "How long have you been writing?", "Give us a follow to support indie publishers!", "Do you like prose or poetry most?", "What's your favorite book?"])

## Additional filters
session.set_skip_users(skip_private=True, private_percentage=100, skip_no_profile_pic=True, no_profile_pic_percentage=100,
 skip_business=False, skip_non_business=False, business_percentage=100, skip_business_categories=[], dont_skip_business_categories=[])

## Dont waste time following people with over 8.5k followers
session.set_relationship_bounds(enabled=True, max_followers=8500)

session.end()
