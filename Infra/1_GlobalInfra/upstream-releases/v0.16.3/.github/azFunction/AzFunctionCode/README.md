# Overview

This folder contains the various functions that are contained in the overall Azure Functions. The following functions are present:

1. timerschedule; this is a simple timer trigger which runs every five hours, and triggers the next function through placing a queue item in the startjob queue.
2. getPullRequests; this is a queue based trigger (startjob queue) which gets the latest x closed pull requests from GitHub. PR title, number and state for each is saved in a queue item in the closedPullRequests queue.
3. getSubscriptions; this is a queue based trigger (closedPullRequests queue), which for each pull request looks for an corresponding, active subscription. If the subscription is found subscription name and id is saved in a queue item in the subscriptionsToClose queue.
4. cancelSubscriptions; this is a queue based trigger (subscriptionsToClose queue), which for each subscription tries to cancel the subscription. If succesful subscription name and id is saved in a queue item in the canceledSubscriptions queue.
