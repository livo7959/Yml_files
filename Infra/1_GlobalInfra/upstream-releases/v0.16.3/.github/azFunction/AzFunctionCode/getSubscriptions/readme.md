# Overview

This function is triggered by items arriving on the closedPullRequests queue as defined in input bindings in the function.json file. Upon triggering the function will try to get the subscription state based on subscription name using Get-AzSubscription. If subscription exists and is active, subscription name and id is placed in the queue subscriptionsToClose on associated storage as specified in output bindings in the function.json file.
