test('Practice Software Testing website API is live', async () => {
  const response = await fetch('https://api.practicesoftwaretesting.com/products');
  
  expect(response.status).toBe(200);
  
  const body = await response.json();
  expect(body.data.length).toBeGreaterThan(0);
});