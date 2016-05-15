var gulp       = require('gulp'),
  concat       = require('gulp-concat'),
  uglify       = require('gulp-uglify'),
  postcss      = require('gulp-postcss'),
  autoprefixer = require('autoprefixer'),
  cssnano      = require('cssnano'),
  del          = require('del');

var javascripts = {
  "all.js": [
    'assets/javascripts/jquery.min.js',
    'assets/javascripts/jquery-migrate.min.js',
    'assets/javascripts/jquery.backstretch.min.js',
    'assets/javascripts/bootstrap.min.js',
    'assets/javascripts/app.js',
    'assets/javascripts/all.js'
  ],
  "ie.js": [
    'assets/javascripts/respond.js',
    'assets/javascripts/html5shiv.js',
    'assets/javascripts/placeholder-IE-fixes.js'
  ]
};

var stylesheets = {
  'all.css': [
    'assets/stylesheets/fonts.css',
    'assets/stylesheets/style.css',
    'assets/stylesheets/app.css',
    'assets/stylesheets/blocks.css',
    'assets/stylesheets/bootstrap.min.css',
    'assets/stylesheets/animate.css',
    'assets/stylesheets/site.css',
    'assets/stylesheets/dark-red.css'
  ]
};

gulp.task('default', ['build', 'watch']);

gulp.task('build', ['javascripts', 'stylesheets']);

gulp.task('javascripts', ['all.js', 'ie.js']);

gulp.task('all.js', function() {
  return gulp
    .src(javascripts['all.js'])
    .pipe(concat('all.js'))
    .pipe(uglify())
    .pipe(gulp.dest('intermediate/javascripts/'));
});

gulp.task('ie.js', function() {
  return gulp
    .src(javascripts['ie.js'])
    .pipe(concat('ie.js'))
    .pipe(uglify())
    .pipe(gulp.dest('intermediate/javascripts/'));
});

gulp.task('stylesheets', ['all.css']);

gulp.task('all.css', function() {
  return gulp
    .src(stylesheets['all.css'])
    .pipe(postcss([
      autoprefixer(),
      cssnano()
    ]))
    .pipe(concat('all.css'))
    .pipe(gulp.dest('intermediate/stylesheets/'));
});

gulp.task('watch', function() {
  gulp.watch(javascripts['all.js'], ['all.js']);
  gulp.watch(javascripts['ie.js'],  ['ie.js']);
  gulp.watch(stylesheets['all.css'], ['all.css']);
});

gulp.task('clean', function() {
  return del(['intermediate']);
});
