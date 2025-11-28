// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DailyChecklistTracker
/// @author Plato
/// @notice Track daily self-discipline habits on-chain and compute streaks.
/// @dev This contract is intentionally simple and gas-inefficient for large histories,
///      but perfect as a learning / portfolio smart contract.
contract DailyChecklistTracker {
    /// @notice Single day log for a given user
    struct DayLog {
        uint64 dateId;        // Day ID = timestamp / 1 days (UTC-based)
        uint64 timestamp;     // Exact block.timestamp when the log was created
        bool didExercise;     // e.g. workout / push-ups
        bool didMeditation;   // meditation / self-analysis
        bool noPorn;          // no pornography for the day
        bool noAlcohol;       // no alcohol for the day
        string note;          // optional free-form note
    }

    /// @dev user => list of logs in chronological order
    mapping(address => DayLog[]) private _logs;

    /// @dev user => (dateId => already logged?)
    mapping(address => mapping(uint256 => bool)) private _hasLoggedDate;

    /// @notice Emitted whenever a user logs a new day
    event DayLogged(
        address indexed user,
        uint64 indexed dateId,
        bool didExercise,
        bool didMeditation,
        bool noPorn,
        bool noAlcohol,
        string note
    );

    /// @notice Log the current day with your self-discipline status.
    /// @param didExercise Whether you exercised today
    /// @param didMeditation Whether you meditated / did self-analysis today
    /// @param noPorn Whether you avoided pornography today
    /// @param noAlcohol Whether you avoided alcohol today
    /// @param note Optional note (can be empty)
    function logToday(
        bool didExercise,
        bool didMeditation,
        bool noPorn,
        bool noAlcohol,
        string calldata note
    ) external {
        uint64 dateId = uint64(block.timestamp / 1 days);
        uint64 ts = uint64(block.timestamp);

        // Ensure the user logs at most once per day
        require(!_hasLoggedDate[msg.sender][dateId], "Already logged today");

        _hasLoggedDate[msg.sender][dateId] = true;

        DayLog memory logEntry = DayLog({
            dateId: dateId,
            timestamp: ts,
            didExercise: didExercise,
            didMeditation: didMeditation,
            noPorn: noPorn,
            noAlcohol: noAlcohol,
            note: note
        });

        _logs[msg.sender].push(logEntry);

        emit DayLogged(
            msg.sender,
            dateId,
            didExercise,
            didMeditation,
            noPorn,
            noAlcohol,
            note
        );
    }

    /// @notice Returns how many daily logs a user has stored.
    /// @param user The address to query
    function getLogsCount(address user) external view returns (uint256) {
        return _logs[user].length;
    }

    /// @notice Returns a specific log entry by index for a given user.
    /// @param user The address to query
    /// @param index The index within that user's log array
    function getLog(address user, uint256 index)
        external
        view
        returns (
            uint64 dateId,
            uint64 timestamp,
            bool didExercise,
            bool didMeditation,
            bool noPorn,
            bool noAlcohol,
            string memory note
        )
    {
        require(index < _logs[user].length, "Index out of bounds");
        DayLog storage entry = _logs[user][index];
        return (
            entry.dateId,
            entry.timestamp,
            entry.didExercise,
            entry.didMeditation,
            entry.noPorn,
            entry.noAlcohol,
            entry.note
        );
    }

    /// @notice Returns the current streak of "successful" days for a user.
    /// @dev A day is considered successful if all four flags are true.
    ///      The streak is based on consecutive dateIds with no gaps.
    /// @param user The address to query
    function getCurrentStreak(address user) external view returns (uint256) {
        uint256 len = _logs[user].length;
        if (len == 0) {
            return 0;
        }

        uint256 streak = 0;
        uint64 lastDateId = _logs[user][len - 1].dateId;

        // Walk backwards until we find a failure or a gap in dates
        for (uint256 i = len; i > 0; i--) {
            DayLog storage entry = _logs[user][i - 1];

            // Gap in days bigger than 1 -> streak ends
            if (lastDateId - entry.dateId > 1) {
                break;
            }

            // Day must be successful
            if (_isSuccessful(entry)) {
                streak += 1;
                lastDateId = entry.dateId; // move the window back
            } else {
                break;
            }
        }

        return streak;
    }

    /// @notice Helper to determine if a day counts as "successful".
    /// @dev You can tweak this logic if you want different rules.
    function _isSuccessful(DayLog storage entry) internal view returns (bool) {
        // For now: all four conditions must be true
        return (
            entry.didExercise &&
            entry.didMeditation &&
            entry.noPorn &&
            entry.noAlcohol
        );
    }
}
