# Overview

This function is triggered by items arriving on the subscriptionsToClose queue as defined in input bindings in the function.json file. Upon triggering the function will cancel the subscription using Azure rest api. If succesful, subscription name and id is placed in the queue canceledSubscriptions on associated storage as specified in output bindings in the function.json file.
