<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
        <sch:pattern name="Check max errors">
        <sch:rule context="/tsa-report/stream-information/total-errors">
            <sch:assert test="@value &lt; 100000">Max errors must be less than 100k</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
