# Overview

This trigger runs every x hours (set by cron syntax in the function.json file). When the trigger runs it creates a queue item in the startjob queue on associated storage as defined by output bindings in the function.json file. This queue item is used to trigger subsequent functions.
