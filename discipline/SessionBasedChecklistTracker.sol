// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title SessionBasedChecklistTracker
/// @author Plato
/// @notice Track self-discipline sessions on-chain and compute streaks.
/// @dev Unlike DailyChecklistTracker, this contract is session-based:
///      each log is a "session" with incremental ID, not tied to calendar days.
contract SessionBasedChecklistTracker {
    /// @notice Single session log for a given user.
    struct SessionLog {
        uint64 sessionId;    // incremental session ID per user
        uint64 timestamp;    // block.timestamp when the session was logged
        bool didExercise;    // workout / physical activity
        bool didMeditation;  // meditation / self-analysis
        bool noPorn;         // no pornography for the session/day
        bool noAlcohol;      // no alcohol for the session/day
        string note;         // optional free-form note
    }

    /// @dev user => list of sessions (ordered by sessionId ascending).
    mapping(address => SessionLog[]) private _sessions;

    /// @dev user => next session id to assign (starts from 1).
    mapping(address => uint64) private _nextSessionId;

    /// @notice Emitted whenever a new session is logged.
    event SessionLogged(
        address indexed user,
        uint64 indexed sessionId,
        bool didExercise,
        bool didMeditation,
        bool noPorn,
        bool noAlcohol,
        string note
    );

    /// @notice Log a new self-discipline session.
    /// @param didExercise Whether you exercised during this session/day.
    /// @param didMeditation Whether you meditated / did self-analysis.
    /// @param noPorn Whether you avoided pornography.
    /// @param noAlcohol Whether you avoided alcohol.
    /// @param note Optional note (can be empty).
    function logSession(
        bool didExercise,
        bool didMeditation,
        bool noPorn,
        bool noAlcohol,
        string calldata note
    ) external {
        uint64 currentId = _nextSessionId[msg.sender] + 1;
        _nextSessionId[msg.sender] = currentId;

        SessionLog memory logEntry = SessionLog({
            sessionId: currentId,
            timestamp: uint64(block.timestamp),
            didExercise: didExercise,
            didMeditation: didMeditation,
            noPorn: noPorn,
            noAlcohol: noAlcohol,
            note: note
        });

        _sessions[msg.sender].push(logEntry);

        emit SessionLogged(
            msg.sender,
            currentId,
            didExercise,
            didMeditation,
            noPorn,
            noAlcohol,
            note
        );
    }

    /// @notice Returns how many sessions a user has logged.
    /// @param user Address to query.
    function getSessionsCount(address user) external view returns (uint256) {
        return _sessions[user].length;
    }

    /// @notice Returns a specific session log by index for a given user.
    /// @param user Address to query.
    /// @param index Index within that user's session array.
    function getSession(address user, uint256 index)
        external
        view
        returns (
            uint64 sessionId,
            uint64 timestamp,
            bool didExercise,
            bool didMeditation,
            bool noPorn,
            bool noAlcohol,
            string memory note
        )
    {
        require(index < _sessions[user].length, "Index out of bounds");
        SessionLog storage entry = _sessions[user][index];
        return (
            entry.sessionId,
            entry.timestamp,
            entry.didExercise,
            entry.didMeditation,
            entry.noPorn,
            entry.noAlcohol,
            entry.note
        );
    }

    /// @notice Returns the current streak of "successful" sessions for a user.
    /// @dev A session is considered successful if all four flags are true.
    ///      Streak is based on consecutive successful sessions from the most recent backwards.
    /// @param user Address to query.
    function getCurrentStreak(address user) external view returns (uint256) {
        uint256 len = _sessions[user].length;
        if (len == 0) {
            return 0;
        }

        uint256 streak = 0;

        // Walk backwards until we hit a failure.
        for (uint256 i = len; i > 0; i--) {
            SessionLog storage entry = _sessions[user][i - 1];
            if (_isSuccessful(entry)) {
                streak += 1;
            } else {
                break;
            }
        }

        return streak;
    }

    /// @notice Returns the last session ID for a user (0 if none).
    function getLastSessionId(address user) external view returns (uint64) {
        return _nextSessionId[user];
    }

    /// @notice Helper to determine if a session counts as "successful".
    /// @dev Currently requires all four conditions to be true.
    function _isSuccessful(SessionLog storage entry)
        internal
        view
        returns (bool)
    {
        return (
            entry.didExercise &&
            entry.didMeditation &&
            entry.noPorn &&
            entry.noAlcohol
        );
    }
}
