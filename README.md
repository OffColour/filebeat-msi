# filebeat-msi

## Overview
WIX file to generate an MSI for Elastic Filebeat

This is a first draft so please take it as it is!

## Tools required

* Wix Tools

## Usage

1. Clone repository
2. Run .\MakeFilebeatMSI.ps1 *http-path-filebeat-zip* (e.g. https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.2-windows-x86_64.zip)
3. MSI generated into the "build" sub-folder
