const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const mapToFolder = (dependencies, folder) =>
  dependencies.reduce((acc, dependency) => {
    return {
      [dependency]: path.resolve(`${folder}/${dependency}`),
      ...acc
    }
  }, {});

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
      './js/app.js': ['./js/app.js']
  },
  output: {
    filename: 'webpack_app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)?$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      }
    ]
  },
  resolve: {
    alias: {
        react: path.resolve(__dirname, './node_modules/react'),
        'react-dom': path.resolve(__dirname, './node_modules/react-dom')
      },
    // alias: {
    //   ...mapToFolder(['react', 'react-dom'], './node_modules')
    // },
    extensions: ['.js', '.jsx']
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/webpack_app.css' })
  ]
});
