const std = @import("std");
const putils = @import("utils").problemUtils;

const Direction = enum { Left, Right, Up, Down };

const Movement = struct {
    distance: i32,
    direction: Direction,
};

const Point = struct {
    x: i32,
    y: i32,

    fn init(x: i32, y: i32) Point {
        return .{
            .x = x,
            .y = y,
        };
    }
};

const StepsPair = struct {
    steps1: u32,
    steps2: u32,

    fn init(steps1: u32, steps2: u32) StepsPair {
        return .{
            .steps1 = steps1,
            .steps2 = steps2,
        };
    }
};

const PointHashSet = std.AutoHashMap(Point, u32);
const PointHashSetMultiValue = std.AutoHashMap(Point, StepsPair);

pub fn solve(allocator: std.mem.Allocator, inputData: []const u8, part: putils.ProblemPart) putils.ProblemError!u32 {
    var iterator = std.mem.splitSequence(u8, inputData, "\n");

    const wire1 = try convertToMovements(allocator, iterator.next());
    const wire2 = try convertToMovements(allocator, iterator.next());
    defer {
        allocator.free(wire1);
        allocator.free(wire2);
    }

    var visitedLocations = try getVisitedLocations(allocator, wire1);
    var duplicateLocations = try findDuplicateLocations(allocator, wire2, &visitedLocations);
    defer {
        visitedLocations.deinit();
        duplicateLocations.deinit();
    }

    if (part == putils.ProblemPart.Part1) {
        return findShortestDistance(&duplicateLocations);
    }
    return findMinSteps(&duplicateLocations);
}

fn convertToMovements(allocator: std.mem.Allocator, wire: ?[]const u8) putils.ProblemError![]Movement {
    if (wire == null) {
        return putils.ProblemError.UnproccessableElementError;
    }

    var iterator = std.mem.splitSequence(u8, wire.?, ",");
    var movements = std.ArrayList(Movement).init(allocator);

    while (iterator.next()) |element| {
        const direction: Direction = switch (element[0]) {
            'R' => Direction.Right,
            'L' => Direction.Left,
            'U' => Direction.Up,
            'D' => Direction.Down,
            else => unreachable,
        };
        const distance = std.fmt.parseInt(i32, element[1..], 10) catch {
            return putils.ProblemError.UnproccessableElementError;
        };
        movements.append(.{
            .distance = distance,
            .direction = direction,
        }) catch {
            return putils.ProblemError.MemoryAllocationError;
        };
    }

    return movements.toOwnedSlice() catch {
        return putils.ProblemError.MemoryAllocationError;
    };
}

fn getVisitedLocations(allocator: std.mem.Allocator, wire: []Movement) putils.ProblemError!PointHashSet {
    var visitedLocations = PointHashSet.init(allocator);
    var currentLocation = Point.init(0, 0);
    var numSteps: u32 = 0;

    for (wire) |movement| {
        if (numSteps != 0) numSteps -= 1;
        switch (movement.direction) {
            Direction.Right => try addHorizontalMovements(
                &visitedLocations,
                &currentLocation,
                movement.distance,
                true,
                &numSteps,
            ),
            Direction.Left => try addHorizontalMovements(
                &visitedLocations,
                &currentLocation,
                movement.distance,
                false,
                &numSteps,
            ),
            Direction.Up => try addVerticalMovements(
                &visitedLocations,
                &currentLocation,
                movement.distance,
                true,
                &numSteps,
            ),
            Direction.Down => try addVerticalMovements(
                &visitedLocations,
                &currentLocation,
                movement.distance,
                false,
                &numSteps,
            ),
        }
    }
    return visitedLocations;
}

fn findDuplicateLocations(
    allocator: std.mem.Allocator,
    wire: []Movement,
    existingLocations: *const PointHashSet,
) putils.ProblemError!PointHashSetMultiValue {
    var duplicateLocations = PointHashSetMultiValue.init(allocator);
    var currentLocation = Point.init(0, 0);
    var numSteps: u32 = 0;

    for (wire) |movement| {
        if (numSteps != 0) numSteps -= 1;
        switch (movement.direction) {
            Direction.Right => try searchHorizontalMovements(
                &duplicateLocations,
                existingLocations,
                &currentLocation,
                movement.distance,
                true,
                &numSteps,
            ),
            Direction.Left => try searchHorizontalMovements(
                &duplicateLocations,
                existingLocations,
                &currentLocation,
                movement.distance,
                false,
                &numSteps,
            ),
            Direction.Up => try searchVerticalMovements(
                &duplicateLocations,
                existingLocations,
                &currentLocation,
                movement.distance,
                true,
                &numSteps,
            ),
            Direction.Down => try searchVerticalMovements(
                &duplicateLocations,
                existingLocations,
                &currentLocation,
                movement.distance,
                false,
                &numSteps,
            ),
        }
    }

    return duplicateLocations;
}

fn addHorizontalMovements(
    visitedLocations: *PointHashSet,
    currentLocation: *Point,
    distance: i32,
    increment: bool,
    numSteps: *u32,
) putils.ProblemError!void {
    for (0..@intCast(distance + 1)) |current| {
        const x: i32 = @intCast(current);
        const newX = if (increment) currentLocation.x + x else currentLocation.x - x;
        visitedLocations.put(Point.init(newX, currentLocation.y), numSteps.*) catch {
            return putils.ProblemError.MemoryAllocationError;
        };
        numSteps.* += 1;
    }
    currentLocation.x += if (increment) distance else -distance;
}

fn searchHorizontalMovements(
    duplicateLocations: *PointHashSetMultiValue,
    existingLocations: *const PointHashSet,
    currentLocation: *Point,
    distance: i32,
    increment: bool,
    numSteps: *u32,
) putils.ProblemError!void {
    for (0..@intCast(distance + 1)) |current| {
        const x: i32 = @intCast(current);
        const newX = if (increment) currentLocation.x + x else currentLocation.x - x;
        const point = Point.init(newX, currentLocation.y);
        const existingLocation = existingLocations.get(point);
        if (existingLocation != null and !(point.x == 0 and point.y == 0)) {
            duplicateLocations.put(point, StepsPair.init(numSteps.*, existingLocation.?)) catch {
                return putils.ProblemError.MemoryAllocationError;
            };
        }
        numSteps.* += 1;
    }
    currentLocation.x += if (increment) distance else -distance;
}

fn addVerticalMovements(
    visitedLocations: *PointHashSet,
    currentLocation: *Point,
    distance: i32,
    increment: bool,
    numSteps: *u32,
) putils.ProblemError!void {
    for (0..@intCast(distance + 1)) |current| {
        const y: i32 = @intCast(current);
        const newY = if (increment) currentLocation.y + y else currentLocation.y - y;
        visitedLocations.put(Point.init(currentLocation.x, newY), numSteps.*) catch {
            return putils.ProblemError.MemoryAllocationError;
        };
        numSteps.* += 1;
    }
    currentLocation.y += if (increment) distance else -distance;
}

fn searchVerticalMovements(
    duplicateLocations: *PointHashSetMultiValue,
    existingLocations: *const PointHashSet,
    currentLocation: *Point,
    distance: i32,
    increment: bool,
    numSteps: *u32,
) putils.ProblemError!void {
    for (0..@intCast(distance + 1)) |current| {
        const y: i32 = @intCast(current);
        const newY = if (increment) currentLocation.y + y else currentLocation.y - y;
        const point = Point.init(currentLocation.x, newY);
        const existingLocation = existingLocations.get(point);
        if (existingLocation != null and !(point.x == 0 and point.y == 0)) {
            duplicateLocations.put(Point.init(currentLocation.x, newY), StepsPair.init(numSteps.*, existingLocation.?)) catch {
                return putils.ProblemError.MemoryAllocationError;
            };
        }
        numSteps.* += 1;
    }
    currentLocation.y += if (increment) distance else -distance;
}

fn findShortestDistance(duplicateLocations: *const PointHashSetMultiValue) u32 {
    var keys = duplicateLocations.keyIterator();
    var shortestDistance: u32 = 0;
    while (keys.next()) |key| {
        const distance: u32 = @abs(key.x) + @abs(key.y);
        if (shortestDistance == 0 or distance < shortestDistance) {
            shortestDistance = distance;
        }
    }
    return shortestDistance;
}

fn findMinSteps(duplicateLocations: *const PointHashSetMultiValue) u32 {
    var values = duplicateLocations.valueIterator();
    var shortestSteps: u32 = 0;
    while (values.next()) |value| {
        const totalSteps = value.steps1 + value.steps2;
        if (shortestSteps == 0 or totalSteps < shortestSteps) {
            shortestSteps = totalSteps;
        }
    }
    return shortestSteps;
}
