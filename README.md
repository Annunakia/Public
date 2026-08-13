# UPR Cross-Segment Data Access Setup and Refresh Process

## Purpose
This document captures the implementation requested for the UPR team to access selected data from multiple broad environment segments through separate UPR landing databases.

## Background
John from Palantir and the UPR team requested cross-segment data access for their use case.

The UPR team needed data from multiple broad environment segments, including:

- GP
- GIS
- GC
- CSDW

Because the UPR segment could not be granted direct access to other broad environment segments, the implemented solution was to provision separate UPR landing databases and clone only the required objects into them.

## Objective
Provide the UPR team with access to required tables and views from source broad databases without granting direct cross-segment access.

## High-Level Solution
The implemented approach was:

1. Create separate UPR landing databases for the requested source domains.
2. Create the required schemas in each destination database.
3. Clone only the requested tables from the source broad databases.
4. Recreate views in the destination when direct cloning of views was not possible.
5. Grant access to the UPR owner role across databases, schemas, tables, future tables, and views.
6. Create scheduled refresh tasks to keep cloned objects updated every 60 minutes.
7. Keep the refresh tasks disabled until business users request activation.

## Databases and Scope
The requests included landing databases for multiple domains, including references in the discussion to:

- GIS landing database
- GP landing database
- GC landing database
- CSVC or CSDW-related landing setup

Note:
The transcript contains a few acronym inconsistencies from speech-to-text, so the exact database names should be validated against the original worksheet and tickets before publishing this as a final operational record.

## Implementation Details

### 1. Database Creation
Separate UPR databases were created to host the requested data copies for the UPR team.

### 2. Schema Creation
Within each landing database, the required schemas were created to mirror the requested source structures from the broad environment.

### 3. Table Cloning
Only the requested tables were cloned from source databases instead of replicating full databases.

This was done to reduce cost and limit the copied scope to only what was required.

### 4. View Handling
Views could not be cloned directly.

To support requested views:

- the underlying source tables were cloned first
- equivalent views were then recreated in the destination database using the original view definitions

### 5. Access Grants
Privileges were granted to the UPR owner role, including:

- database access
- schema access
- future schema access
- table access
- future table access
- view access

Where table cloning used `COPY GRANTS`, original grants were preserved on cloned tables, reducing the need for repeated manual re-granting.

### 6. Refresh Task Setup
A refresh task was created for each landing database.

Task design:

- one task per destination database
- task created under the `public` schema
- task includes the clone or replace logic for all required schemas and tables in that database
- refresh frequency set to every 60 minutes
- warehouse used: `UPR DEV LOAD` warehouse, large size
- initial status: suspended or disabled

Reason for disabled status:
The business team did not require immediate activation and planned to request enablement when ready.

## Important Notes and Exceptions

### Missing Tables
At least three originally requested tables were not present in the source broad environment.

This was confirmed upstream, and those tables were excluded from implementation.

### Views Require Manual Recreation
Since views cannot be cloned directly, the implemented workaround was:

- clone base tables
- recreate views in the destination environment

### GIS Details May Be Incomplete in Current Worksheet
The current worksheet maintained by the implementer does not appear to include the full GIS details.

Those details should be supplemented from:

- John's original worksheet
- John's chat message
- original request tickets

## Operational Process Followed
The implementation was executed manually through worksheets using SQL statements maintained over time.

The general operational flow was:

1. Review the request ticket and list of required schemas, tables, and views.
2. Create the destination UPR landing database.
3. Create corresponding schemas in the destination.
4. Clone requested tables from the source broad database.
5. Recreate requested views where needed.
6. Grant access to the UPR owner role.
7. Create a refresh task in `public`.
8. Schedule the task for 60-minute refresh intervals.
9. Leave the task suspended until activation is requested.

## Source Artifacts to Reference
Before final publication, add links or references to:

- original request tickets
- John's original worksheet
- follow-up worksheet used for the later requests
- any chat thread where John documented the earlier GIS implementation
- any internal runbook or Data Operations Confluence page where similar work is stored

## Open Items
The following should be confirmed before marking this documentation final:

- exact Confluence location for this page
- exact landing database names
- exact schema names
- exact source-to-destination mapping
- final list of requested tables and views
- ticket IDs associated with the original and follow-up requests
- whether a separate artifact was created by John for the original GIS request
- whether and when the suspended refresh tasks should be enabled

## Recommended Attachments
Attach or link the following if available:

- SQL worksheet used for database and schema creation
- SQL used for table cloning
- SQL used for recreated views
- SQL task definitions
- screenshots or exports from the worksheet history
- ticket references and approvals

## Summary
The UPR team needed controlled access to data from multiple broad environment segments.

Direct cross-segment access was not allowed, so separate UPR landing databases were created. Required tables were cloned, requested views were recreated, privileges were granted to the UPR owner role, and scheduled refresh tasks were configured to run every 60 minutes but left disabled pending activation.
