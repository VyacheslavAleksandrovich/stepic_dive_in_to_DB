select commander.name, spacecraft.name, flight.start_date
    from Commander as commander JOIN Flight as flight ON
        (commander.id = flight.commander_id)
    JOIN Spacecraft as spacecraft ON
        (spacecraft.id = flight.spacecraft_id)
    WHERE commander.id = 6;

# Type your query above this line.
