<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:ns uri="http://www.ffmpeg.org/schema/ffprobe" prefix="ffprobe"/>
    <sch:pattern name="Check format name">
        <sch:rule context="ffprobe:ffprobe/format">
            <sch:assert test="@format_name = 'mpegts'">The format must be mpeg transport stream</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
