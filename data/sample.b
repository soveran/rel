rel Items {
  id: int,
  pid: int,
  ts: long,
}

rel Process {
  pid: int
}

queue: Items;

fn push(i: Items) {
  queue += i - queue project(id);
}

fn list(): Items {
  return queue;
}

fn in_process(): Items {
  return queue select(pid != 0);
}

fn clear() {
  queue -= queue;
}

fn fetch(p: Process): Items {

  # Get the oldest free item.
  q1 := queue select(pid == 0)
              summary(id = min(id, 0),
                      ts = min(ts, 0L));

  # Mark the item with the process id.
  q2 := q1 * p;

  # Update the queue with the new item.
  queue = queue - q1 extend(pid = 0) + q2;

  # Return the updated record.
  return q2;
}

# Remove an item from the queue.
fn delete(i: Items) {
  queue = queue - i;
}
