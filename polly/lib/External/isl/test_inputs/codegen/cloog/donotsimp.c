for (int c0 = 1; c0 <= 10; c0 += 1) {
  for (int c1 = 1; c1 <= c0; c1 += 1)
    S1(c0, c1);
  for (int c1 = 11; c1 <= M; c1 += 1)
    S2(c0, c1);
}
