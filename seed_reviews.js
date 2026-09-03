const admin = require("firebase-admin");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const auth = admin.auth();
const db = admin.firestore();

const PASSWORD = "password123";
const SNEAKER_COUNT = 56;

const usersToCreate = [
  ["alex.johnson@test.com", "Alex Johnson"],
  ["emma.williams@test.com", "Emma Williams"],
  ["daniel.brown@test.com", "Daniel Brown"],
  ["sophia.miller@test.com", "Sophia Miller"],
  ["michael.davis@test.com", "Michael Davis"],
  ["olivia.wilson@test.com", "Olivia Wilson"],
  ["james.anderson@test.com", "James Anderson"],
  ["mia.thomas@test.com", "Mia Thomas"],
  ["ethan.martin@test.com", "Ethan Martin"],
  ["ava.jackson@test.com", "Ava Jackson"],
].map(([email, displayName]) => ({ email, displayName, password: PASSWORD }));

const reviewComments = [
  "Very comfortable sneakers, perfect for daily use.",
  "The quality feels good and the design is clean.",
  "Lightweight, stylish, and easy to wear every day.",
  "Great pair for walking and casual outfits.",
  "The sole feels soft and the build quality is solid.",
  "The size fits well and comfort is better than expected.",
  "Good balance between comfort and style.",
  "Nice cushioning and good support.",
  "The pair feels reliable and looks fashionable.",
  "Great fit and the shoes look premium.",
];

function ratingFor(sneakerId, userIndex) {
  return 3 + ((sneakerId + userIndex) % 3);
}

function commentFor(sneakerId, userIndex) {
  return reviewComments[(sneakerId + userIndex) % reviewComments.length];
}

function timestampFor(sneakerId, userIndex) {
  const date = new Date();
  date.setDate(date.getDate() - ((sneakerId + userIndex) % 30));
  date.setHours(date.getHours() - (userIndex % 12));
  return admin.firestore.Timestamp.fromDate(date);
}

async function createOrGetUser(userData) {
  try {
    const existingUser = await auth.getUserByEmail(userData.email);
    await auth.updateUser(existingUser.uid, {
      displayName: userData.displayName,
      emailVerified: true,
    });
    console.log(`User ready: ${userData.email}`);
    return auth.getUser(existingUser.uid);
  } catch (error) {
    if (error.code !== "auth/user-not-found") throw error;

    const newUser = await auth.createUser({
      email: userData.email,
      password: userData.password,
      displayName: userData.displayName,
      emailVerified: true,
    });
    console.log(`Created user: ${userData.email}`);
    return newUser;
  }
}

async function writeReview(sneakerId, user, userIndex) {
  const rating = ratingFor(sneakerId, userIndex);
  const comment = commentFor(sneakerId, userIndex);
  const timestamp = timestampFor(sneakerId, userIndex);
  const userName = user.displayName || `Customer ${userIndex + 1}`;

  const reviewData = {
    sneakerId,
    email: user.email,
    userEmail: user.email,
    userId: user.uid,
    userName,
    name: userName,
    text: comment,
    comment,
    rating,
    date: timestamp,
    createdAt: timestamp,
  };

  await db
    .collection("reviews")
    .doc(String(sneakerId))
    .collection("items")
    .doc(user.uid)
    .set(reviewData, { merge: true });
}

async function seed() {
  console.log("Starting Firebase seed...");

  const users = [];
  for (const userData of usersToCreate) {
    users.push(await createOrGetUser(userData));
  }

  let totalReviews = 0;
  for (let sneakerId = 1; sneakerId <= SNEAKER_COUNT; sneakerId++) {
    for (let i = 0; i < users.length; i++) {
      await writeReview(sneakerId, users[i], i);
      totalReviews++;
    }
  }

  console.log("Seed completed.");
  console.log(`Users ready: ${users.length}`);
  console.log(`Sneakers covered: ${SNEAKER_COUNT}`);
  console.log(`Reviews written: ${totalReviews}`);
}

seed()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Seed failed:");
    console.error(error);
    process.exit(1);
  });
