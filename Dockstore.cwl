baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: url-fetcher
inputs:
  new_name:
    doc: A new name for the downloaded file to be renamed into, if you don't want
      it to be called by its original name based on the URL.
    inputBinding:
      position: 2
      prefix: --new_name
    type: string?
  url:
    doc: The URL of the file to be fetched.
    inputBinding:
      position: 1
      prefix: --url
    type: string
label: Fetch file from URL
outputs:
  fetched_file:
    doc: The resulting fetched file.
    outputBinding:
      glob: fetched_file/*
    type: File
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/url-fetcher:3
s:author:
  class: s:Person
  s:name: George Asimenos
